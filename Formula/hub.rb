class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.9.tar.gz"
  sha256 "b3f949c4500288a18ed68c38755962c9571c9e10063fb77583a19d0fcca5ecdf"

  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f000de1097dfd51b978193a32793aa29d7e9e040418bf2459565cb1f3a670bb" => :high_sierra
    sha256 "6c23abd1255f04855fc1dfb8d44706337b728b5785e5b79f2319637575be93c7" => :sierra
    sha256 "3452a355c8e4ef25714be7105d8946e01319e7760ffe97f7df3fc9dd21c89c76" => :el_capitan
    sha256 "3f116b4c0587ab5d2a87d9d2f013ea058407ac2f9e845461d4970f36548e6be4" => :yosemite
  end

  devel do
    url "https://github.com/github/hub/archive/v2.3.0-pre10.tar.gz"
    sha256 "4096b95aea46f674e91ff0d83f86d876958024a02c50ffb1e3a4aac3e0536fc5"
  end

  option "without-completions", "Disable bash/zsh completions"
  option "without-docs", "Don't install man pages"

  depends_on "go" => :build

  def install
    if build.stable?
      system "script/build", "-o", "hub"
      bin.install "hub"
      man1.install Dir["man/*"] if build.with? "docs"
    elsif build.with? "docs"
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
      # TODO: Remove the conditional when hub 2.3.0 is released.
      fish_completion.install "etc/hub.fish_completion" => "hub.fish" unless build.stable?
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
