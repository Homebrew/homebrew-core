class Naturaldocs < Formula
  desc "Extensible, multi-language documentation generator"
  homepage "https://www.naturaldocs.org/"
  license "AGPL-3.0-only"

  stable do
    url "https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/2.3.1/Natural_Docs_2.3.1.zip"
    mirror "https://naturaldocs.org/download/natural_docs/2.3.1/Natural_Docs_2.3.1.zip"
    sha256 "92144e2deb1ff2606d29343cfea203ea890549ad2f77c03df1cea2d8014972cb"
    depends_on "mono"
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/Natural.?Docs[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a439b159358c64b91076716aa62efc0f80cd08938a4a35daa35dd397817a474a"
  end

  head do
    url "https://github.com/NaturalDocs/NaturalDocs.git", branch: "main"
    depends_on "dotnet"
  end

  def install
    if build.head?
      ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

      os = OS.mac? ? "macOS" : "Linux"
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s.upcase
      dotnet = Formula["dotnet"]
      args = %W[
        --configuration Release
        --framework net#{dotnet.version.major_minor}
        --output #{libexec}
        --no-self-contained
        --use-current-runtime
        -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
        -p:Platform=#{os}_#{arch}
      ]

      system "dotnet", "publish", "CLI/CLI.csproj", *args
      bin.install_symlink libexec/"NaturalDocs" => "naturaldocs"
    else
      os = OS.mac? ? "Mac" : "Linux"
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

      libexec.install Dir["*"]
      (bin/"naturaldocs").write <<~BASH
        #!/bin/bash
        mono #{libexec}/NaturalDocs.exe "$@"
      BASH

      libexec.install_symlink etc/"naturaldocs" => "Config"

      libexec.glob("libSQLite.*").each do |f|
        rm f if f.basename.to_s != "libSQLite.#{os}.#{arch}"
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/naturaldocs -v")

    output = shell_output("#{bin}/naturaldocs --list-encodings")
    assert_match "Unicode (UTF-8)", output
  end
end
