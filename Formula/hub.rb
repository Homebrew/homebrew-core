class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.8.3.tar.gz"
  sha256 "26bc1bc6fd8b6af379445728450d9c1e26a6d1861fdff5c2b552562eb7487a96"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5804cf15d5df91051c329e945fcaaf1652e7af288536563581fc35b9a34feb32" => :mojave
    sha256 "568f2e999b526ffd9ae147d6ce3ecfa2d92f1bd7208777d661d9ad4f2973253d" => :high_sierra
    sha256 "38e92da3941f5a15110c01a9ce6e9a15ef79b6b26c7936bcd628af5de50f14fe" => :sierra
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
