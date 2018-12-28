class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.7.0.tar.gz"
  sha256 "58d131c32404c963b06bcc067bda14317bc22be26187026a91960aecda324bf4"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb550899ba3aa031b74e3bb98fd1ed6e05592bc6af107923e4de9a2904d6f9bf" => :mojave
    sha256 "3e1ae8c16f7155704ec84b948e3ea3ec77eda9cb8042829e991bcc1397f7bed2" => :high_sierra
    sha256 "cfd054beb1f03e0ead7f0bf5f6f2d3cc583a0c773f664b07f443f2575ac4dbb9" => :sierra
  end

  depends_on "go" => :build

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/hub").install buildpath.children
    cd "src/github.com/github/hub" do
      begin
        deleted = ENV.delete "SDKROOT"
        ENV["GEM_HOME"] = buildpath/"gem_home"
        system "gem", "install", "bundler"
        ENV.prepend_path "PATH", buildpath/"gem_home/bin"
        system "make", "man-pages"
      ensure
        ENV["SDKROOT"] = deleted
      end
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
