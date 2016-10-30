class Ironcli < Formula
  desc "Go version of the Iron.io command-line tools"
  homepage "https://github.com/iron-io/ironcli"
  head "https://github.com/iron-io/ironcli.git"

  stable do
    url "https://github.com/iron-io/ironcli/archive/0.1.2.tar.gz"
    sha256 "ff4d8b87f3dec4af83e6a907b3a857e24ceb41fabd2baa4057aae496b12324e6"

    # fixes the version
    patch do
      url "https://github.com/iron-io/ironcli/commit/1fde89f1.patch"
      sha256 "d037582e62073ae56b751ef543361cc381334f747b4547c0ccdf93df0098dba5"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f329dac399b4e91562aaf13592dadd94fcc2f6d94f3ce09fec1e46a160a64a27" => :sierra
    sha256 "f4a49366543c6876ef16fd3cbe4c123255f4b68db200be460d9a277771e8d40c" => :el_capitan
    sha256 "4d57b9a215dacf866ab2a06cb8468a99de7aace1c8b2d0deaf3239879959716f" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/iron-io/ironcli"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"iron"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/iron --version").chomp
  end
end
