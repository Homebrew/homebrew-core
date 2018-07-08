class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.5.0.tar.gz"
  sha256 "8e3bda092ddc81eaf208c5fd2b87f66e030012129d55fa631635c6adf8437941"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "662fff8ecc2f7e283016efca23b6d4253e117fdadf33958dec2bd0b5bfb2e630" => :high_sierra
    sha256 "bc784dd6a4de80101cd368e055628c278f0b776979aef34b0026f2f3532644d7" => :sierra
    sha256 "4bfadde784d7ea3309f20d635d0c765d72fb03116a7eef49697b7649b01eb128" => :el_capitan
  end

  option "without-completions", "Disable bash/zsh completions"
  option "without-docs", "Don't install man pages"

  depends_on "go" => :build

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/hub").install buildpath.children
    cd "src/github.com/github/hub" do
      if build.with? "docs"
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
      else
        system "script/build", "-o", "hub"
        bin.install "hub"
      end

      prefix.install_metafiles

      if build.with? "completions"
        bash_completion.install "etc/hub.bash_completion.sh"
        zsh_completion.install "etc/hub.zsh_completion" => "_hub"
        fish_completion.install "etc/hub.fish_completion" => "hub.fish"
      end
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
