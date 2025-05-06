class Jpegrescan < Formula
  desc "Losslessly shrink any JPEG file"
  homepage "https://github.com/kud/jpegrescan"
  url "https://github.com/kud/jpegrescan/archive/refs/tags/1.1.0.tar.gz"
  sha256 "a8522e971d11c904f4b61af665c3be800f26404e2b14f5f80c675b4a72a42b32"
  license :public_domain
  revision 1
  head "https://github.com/kud/jpegrescan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2bdbe245fbd20be8c2d34f4ce46408effedd4e7c99d516fbbd78e2321284219c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaf688d3c8d50fc17fbe0f5a8ca91c700785478bc47e063535216822b9ec8593"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7431fe05859f4cd0b88e7aa736e9b455a99fb06f09503f16e32ba84538227863"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7e337050c5026743c9ef33c6b49423de22348cbac8f28f2a49f4635a52232d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7e337050c5026743c9ef33c6b49423de22348cbac8f28f2a49f4635a52232d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaf688d3c8d50fc17fbe0f5a8ca91c700785478bc47e063535216822b9ec8593"
    sha256 cellar: :any_skip_relocation, ventura:        "7431fe05859f4cd0b88e7aa736e9b455a99fb06f09503f16e32ba84538227863"
    sha256 cellar: :any_skip_relocation, monterey:       "b7e337050c5026743c9ef33c6b49423de22348cbac8f28f2a49f4635a52232d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7e337050c5026743c9ef33c6b49423de22348cbac8f28f2a49f4635a52232d5"
    sha256 cellar: :any_skip_relocation, catalina:       "b7e337050c5026743c9ef33c6b49423de22348cbac8f28f2a49f4635a52232d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bac1bb840c090e49e0d900a61448ba4ed094fa29e758f6f7f3803e0e1d89ab3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e57f2d0e5e4c03913297ea1c9d1c41164756dffd1899e89b4024125bf81477f2"
  end

  deprecate! date: "2024-04-05", because: :repo_archived
  disable! date: "2025-04-08", because: :repo_archived

  depends_on "jpeg-turbo"

  uses_from_macos "perl"

  resource "File::Slurp" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/File-Slurp-9999.32.tar.gz"
      sha256 "4c3c21992a9d42be3a79dd74a3c83d27d38057269d65509a2f555ea0fb2bc5b0"
    end
  end

  def install
    env = { PATH: "#{Formula["jpeg-turbo"].opt_bin}:$PATH" }
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      env["PERL5LIB"] = ENV["PERL5LIB"]
      resource("File::Slurp").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end
    bin.install "jpegrescan"
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    system bin/"jpegrescan", "-v", test_fixtures("test.jpg"), testpath/"out.jpg"
    assert_path_exists testpath/"out.jpg"
  end
end
