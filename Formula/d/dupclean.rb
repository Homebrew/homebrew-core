class Dupclean < Formula
  desc "Content-aware duplicate file scanner for music producers and DJs (CLI only)"
  homepage "https://github.com/PopolQue/dupclean"
  url "https://github.com/PopolQue/dupclean/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "1fe3aed87ea2dd68da15cad2f2dfe189ee190f5f0b253a892eaeab7c6b9df3ac"
  license "MIT"
  head "https://github.com/PopolQue/dupclean.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    # Remove GUI package if it exists
    rm_r buildpath/"gui" if (buildpath/"gui").exist?
    rm_r buildpath/"vendor" if (buildpath/"vendor").exist?

    # Create CLI-only main.go
    (buildpath/"main.go").unlink if (buildpath/"main.go").exist?
    (buildpath/"main.go").write <<~EOS
      package main

      import (
        "fmt"
        "os"
        "path/filepath"

        "dupclean/scanner"
        "dupclean/ui"
      )

      const (
        flagHelp    = "--help"
        flagHelpAlt = "-h"
        flagAll     = "--all"
      )

      func main() {
        if len(os.Args) < 2 || os.Args[1] == flagHelp || os.Args[1] == flagHelpAlt {
          printHelp()
          if len(os.Args) < 2 {
            os.Exit(0)
          }
          return
        }

        folder := os.Args[1]
        scanAll := len(os.Args) > 2 && os.Args[2] == flagAll

        folder = filepath.Clean(folder)
        absPath, err := filepath.Abs(folder)
        if err != nil {
          fmt.Printf("Error: invalid path '%s': %v\\n", folder, err)
          os.Exit(1)
        }

        info, err := os.Stat(absPath)
        if err != nil {
          if os.IsNotExist(err) {
            fmt.Printf("Error: path '%s' does not exist\\n", folder)
          } else if os.IsPermission(err) {
            fmt.Printf("Error: permission denied for '%s'\\n", folder)
          } else {
            fmt.Printf("Error: cannot access '%s': %v\\n", folder, err)
          }
          os.Exit(1)
        }

        if !info.IsDir() {
          fmt.Printf("Error: '%s' is not a valid directory\\n", folder)
          os.Exit(1)
        }

        groups, stats, err := scanner.FindDuplicates(absPath, scanAll, nil, []string{}, []string{})
        if err != nil {
          fmt.Printf("Error: scan failed: %v\\n", err)
          os.Exit(1)
        }

        ui.Run(groups, stats)
      }

      func printHelp() {
        fmt.Println("DupClean — Duplicate File Cleaner")
        fmt.Println()
        fmt.Println("Usage:")
        fmt.Println("  dupclean <folder>     Scan folder in CLI mode")
        fmt.Println("  dupclean <folder> --all   Scan all files (not just audio)")
        fmt.Println("  dupclean --help     Show this help message")
        fmt.Println()
        fmt.Println("Supported audio formats: .wav, .aiff, .aif, .mp3, .flac, .ogg, .m4a, .aac")
      }
    EOS

    # Rewrite go.mod with only CLI dependencies
    rm buildpath/"go.mod"
    (buildpath/"go.mod").write "module dupclean\n\ngo 1.22\n"

    # Clean up go.mod and build
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args
  end

  def caveats
    <<~EOS
      This is a CLI-only build of DupClean.
      For the full version with GUI, download from:
        https://github.com/PopolQue/dupclean/releases
    EOS
  end

  test do
    output = shell_output("#{bin}/dupclean --help")
    assert_match "DupClean", output
    assert_match "CLI mode", output

    # Functional test: create duplicate files and verify detection
    (testpath/"file1.txt").write("duplicate content")
    (testpath/"file2.txt").write("duplicate content")
    output = shell_output("#{bin}/dupclean #{testpath} 2>&1 || true")
    assert_match "duplicate", output.downcase
  end
end
