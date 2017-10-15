class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.12.tar.gz"
  sha256 "cf8511bd283fe9fdc7fdf493706e9f8b4902f27b9d51e6a6dc601e16472cd129"

  bottle do
    cellar :any_skip_relocation
    sha256 "085f1b8d6cfa32b4d8e06cec08effbf715282a16d92d5e805c54f835256d3cd3" => :high_sierra
    sha256 "e1cc7112c0c0413176d1bfd01f6ed6542c76bbc9a823b028a6aced2298c16803" => :sierra
    sha256 "6d4e506898b183df56816c978f18bc6a06bc2711753780591b257beb7a7431f0" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/barnybug"
    ln_s buildpath, buildpath/"src/github.com/barnybug/cli53"

    system "make", "build"
    bin.install "cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
