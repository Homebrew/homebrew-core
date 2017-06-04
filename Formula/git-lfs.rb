class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.1.1.tar.gz"
  sha256 "655c1e9bf931afb958c2b81de5c1c38b3ebd6831a04ca5fdcf58cba05e2948d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "beb9826536e9be17bea8c09e4adcfd532782dc267966136061c4e3f63f531346" => :sierra
    sha256 "7672101cbeb1e55b9f138d5f483f03292bf914078943af496c780d283112c30d" => :el_capitan
    sha256 "7fa48298bde3ff306a154970a7cc5dd33170fd80d322a98e24d8aeb1a05661ed" => :yosemite
  end

  depends_on "go" => :build

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

  def caveats; <<-EOS.undent
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
