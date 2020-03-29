class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.13.1.tar.gz"
  sha256 "83275a4c36f66b831ba4864d1f5ffdc823616ed0a8e41b2a9a3e9fcba9279e27"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7969a147539fa423bcb85e346b9d894284605f2e5150de6ebe986c74f0fddcf3" => :catalina
    sha256 "79ba70c505baddd02e912ce5608ea00273afd56bc9c6ac051e325ee7281e23c3" => :mojave
    sha256 "d8db3a284b39a5e007b7cf61ed1bdb3be75b7c9b248ea14312f187b5aae92c4c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-ldflags",
             "-X github.com/elves/elvish/pkg/buildinfo.Version=#{version}",
             "-o", bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
