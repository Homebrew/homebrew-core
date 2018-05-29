class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.3.0.tar.gz"
  sha256 "69e48105f7287537e7afaf969825666c1f09267eae3507515151900487342fae"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "029c71d794ddb92e021577f91d134817da6d75e0df1a04a2c20f9fad03fa496d" => :high_sierra
    sha256 "ac821c5a9a11c716b65508c8015422ac76c33f8b03d31102f2212a2b9adc5b0a" => :sierra
    sha256 "be0e7cf65165022377d43a4261cb4a16994e991cd3acc09e49205c10dfee65ee" => :el_capitan
  end

  option "without-completions", "Disable bash/zsh completions"
  option "without-docs", "Don't install man pages"

  depends_on "go" => :build

  # The build needs Ruby 1.9 or higher.
  depends_on "ruby" => :build if MacOS.version <= :mountain_lion

  def install
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

    if build.with? "completions"
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
