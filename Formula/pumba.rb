class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.6.4.tar.gz"
  sha256 "099e12554997c216d8eaae69ead5ff27517fa12954017b6e222a186171a23464"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "247794d0ef37e5eb999c989e0e8c5fb3bf8f2b61ec35e93b94321cbff5c2b79a" => :mojave
    sha256 "72f425c3c11e1c08da7485cf6f7db1d771a2f914f342f4f61f0d273e12fc9b8e" => :high_sierra
    sha256 "a8993fca0b1692e8e3eebeec02fb531716867366d6d54a22222697b41d4375d7" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/alexei-led/pumba"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"pumba", "-ldflags",
             "-X main.Version=#{version}", "./cmd"
      prefix.install_metafiles
    end
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
