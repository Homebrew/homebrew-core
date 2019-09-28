class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.12.7.tar.gz"
  sha256 "53d812b09aed87c49cc62d09a8827c2dfe7b776732b71287b800320bd23ea028"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "41ee9c023fd6ccf514f78e6af07b4fae92dd6d3668bf4a8400c176729b4d125c" => :catalina
    sha256 "38d6c2855230a34a2e3dc8f5994dfb23cb5d8996fefb637cca9cdf99d37818d1" => :mojave
    sha256 "2a16ffbae2ed1801aa76706776619d095efd6525a5ae0ec90b211bfcf792f26f" => :high_sierra
    sha256 "c795dc0c36bc999b250fa4faa1c0f0b25d9bbbfd65c8f61e58386909b9b07b7f" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/hub").install buildpath.children
    cd "src/github.com/github/hub" do
      system "make", "install", "prefix=#{prefix}"

      prefix.install_metafiles

      bash_completion.install "etc/hub.bash_completion.sh"
      zsh_completion.install "etc/hub.zsh_completion" => "_hub"
      fish_completion.install "etc/hub.fish_completion" => "hub.fish"
    end
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/hub ls-files").strip
  end
end
