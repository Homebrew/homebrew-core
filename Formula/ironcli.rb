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
    sha256 "702e9827fa107852be2ea8ca5d6a6078c60280bfd66a04c70578acd3baa574c5" => :el_capitan
    sha256 "d1187399d5bc8626131baa41107d6c351ffb2ff35807c3e72f35c5c82f625b7d" => :yosemite
    sha256 "28af698978a598c7e9bb0b090e4e9ab5f8eb384ff226caf946d47fc4eb904b35" => :mavericks
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
