class GrimReaper < Formula
  desc "Death-defying data protection - Unified backup, monitoring, and security system"
  homepage "https://grim.so"
  url "https://get.grim.so/latest.tar.gz"
  version "1.0.36"
  sha256 "5f825d48716966bd52ce7fc83d1c706534af5774a0d82ba6b7b414f4eee4d4c2"
  license "BBL"

  depends_on "python@3.11"
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    # Set Grim environment variables
    ENV["GRIM_ROOT"] = prefix
    ENV["GRIM_LICENSE"] = "FREE"
    ENV["GRIM_REAPER"] = "FALSE"

    # Extract tarball (Homebrew auto-handles get.grim.so download)
    # Files are already extracted by Homebrew to buildpath

    # Install Python components
    system "python3", "-m", "pip", "install", "--prefix=#{prefix}", "."
    
    # Build Go components
    cd "go_grim" do
      system "go", "build", "-o", "#{bin}/grim-compression", "."
    end

    # Install shell scripts
    (prefix/"sh_grim").install Dir["sh_grim/*"]
    (prefix/"throne").install Dir["throne/*"]
    (prefix/"bin").install Dir["bin/*"]

    # Make scripts executable
    Dir["#{prefix}/sh_grim/*.sh"].each { |f| File.chmod(0755, f) }
    Dir["#{prefix}/throne/*.sh"].each { |f| File.chmod(0755, f) }
    Dir["#{prefix}/bin/*"].each { |f| File.chmod(0755, f) }

    # Install main grim command
    (bin/"grim").write <<~EOS
      #!/bin/bash
      export GRIM_ROOT="#{prefix}"
      export GRIM_LICENSE="FREE"
      export GRIM_REAPER="FALSE"
      exec "#{prefix}/throne/grim_throne.sh" "$@"
    EOS
  end

  def post_install
    # Create necessary directories
    (var/"grim/logs").mkpath
    (var/"grim/backups").mkpath
    (var/"grim/config").mkpath

    # Set up graveyard symlink
    graveyard_dir = "#{Dir.home}/.graveyard"
    unless File.exist?(graveyard_dir)
      system "mkdir", "-p", graveyard_dir
      system "ln", "-sf", prefix.to_s, "#{graveyard_dir}/reaper"
    end

    puts <<~EOS
      🗡️  Grim Reaper installed successfully!
      
      Usage:
        grim help          - Show available commands
        grim backup        - Start backup operations
        grim monitor       - Monitor system health
        grim scan          - Scan for threats
      
      Configuration:
        GRIM_ROOT=#{prefix}
        GRIM_LICENSE=FREE
        
      For more information: https://grim.so
    EOS
  end

  test do
    # Test that grim command works
    assert_match "Grim Reaper", shell_output("#{bin}/grim --version")
    
    # Test environment variables
    assert_equal prefix.to_s, shell_output("#{bin}/grim config show | grep GRIM_ROOT").strip.split("=")[1]
    
    # Test components exist
    assert_predicate prefix/"sh_grim/backup.sh", :exist?
    assert_predicate prefix/"throne/grim_throne.sh", :exist?
  end
end 