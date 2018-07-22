class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.4.2.tar.gz"
  sha256 "130a552a27c8f324ac0548baf9db0519c4ae96c26a85f926c07ebe0f15a69fc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce479c1e882e71424b31f99712df288fbf77935f85d27f9f0cdbbdedc774dc92" => :high_sierra
    sha256 "83fb6dce04da20d262d966b54b256471779afeccc0c17d3171d14a8442255477" => :sierra
    sha256 "845e5877f4d1beb7ad15a7b9a078b4d820ff1f8392827ec42c8cbf7fd48850ba" => :el_capitan
  end

  depends_on "go" => :build

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

  def install
    begin
      deleted = ENV.delete "SDKROOT"
      ENV["GEM_HOME"] = buildpath/"gem_home"
      system "gem", "install", "ronn"
      ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    ensure
      ENV["SDKROOT"] = deleted
    end

    system "./script/bootstrap"
    system "./script/man"

    bin.install "bin/git-lfs"
    man1.install Dir["man/*.1"]
    doc.install Dir["man/*.html"]
  end

  def caveats; <<~EOS
    Update your git config to finish installation:

      # Update global git config
      $ git lfs install

      # Update system git config
      $ git lfs install --system
  EOS
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
