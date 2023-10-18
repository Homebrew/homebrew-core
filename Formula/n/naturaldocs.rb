class Naturaldocs < Formula
  desc "Extensible, multi-language documentation generator"
  homepage "https://www.naturaldocs.org/"
  url "https://downloads.sourceforge.net/project/naturaldocs/Stable%20Releases/2.3/Natural_Docs_2.3.zip"
  mirror "https://naturaldocs.org/download/natural_docs/2.3/Natural_Docs_2.3.zip"
  sha256 "37dcfeaa0aee2a3622adc85882edacfb911c2e713dba6592cbee6812deddd2f2"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/Natural.?Docs[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46d41e17b53b336d1db203a705164e735af1db6021cc973d126de1091fb8ce0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46d41e17b53b336d1db203a705164e735af1db6021cc973d126de1091fb8ce0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "46d41e17b53b336d1db203a705164e735af1db6021cc973d126de1091fb8ce0c"
    sha256 cellar: :any_skip_relocation, ventura:        "46d41e17b53b336d1db203a705164e735af1db6021cc973d126de1091fb8ce0c"
    sha256 cellar: :any_skip_relocation, monterey:       "46d41e17b53b336d1db203a705164e735af1db6021cc973d126de1091fb8ce0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "46d41e17b53b336d1db203a705164e735af1db6021cc973d126de1091fb8ce0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44e058e2339a3d6113ac8564fa1b9557c1b93783f541a82a463d03b82f45fb8e"
  end

  depends_on "mono"

  def install
    rm_f "libNaturalDocs.Engine.SQLite.Mac32.so"

    os = OS.mac? ? "Mac" : "Linux"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    libexec.install Dir["*"]
    (bin/"naturaldocs").write <<~EOS
      #!/bin/bash
      mono #{libexec}/NaturalDocs.exe "$@"
    EOS

    libexec.install_symlink etc/"naturaldocs" => "config"

    libexec.glob("libSQLite.*").each do |f|
      rm f if f.basename.to_s != "libSQLite.#{os}.#{arch}"
    end
  end

  test do
    system "#{bin}/naturaldocs", "-h"
  end
end
