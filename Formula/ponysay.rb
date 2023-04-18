class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "https://github.com/erkin/ponysay/"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/erkin/ponysay.git", branch: "master"

  stable do
    url "https://github.com/erkin/ponysay/archive/3.0.3.tar.gz"
    sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"

    # upstream commit 16 Nov 2019, `fix: do not compare literal with "is not"`
    patch do
      url "https://github.com/erkin/ponysay/commit/69c23e3a.patch?full_index=1"
      sha256 "2c58d5785186d1f891474258ee87450a88f799408e3039a1dc4a62784de91b63"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02c08b336e498548b23192de0e1fb91f9acd63c56c1bc5d3128b680b78c49467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cd34a134f11b527838ccc5efeca9cc880af360706c58807956b1f4e5677f1bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe930dcefbd56d918a49219076728d073a5aae1488b9aff703ff6fa3e2695468"
    sha256 cellar: :any_skip_relocation, ventura:        "6f2049df606cba06f2591dae3a2ce085e9ff0c5a3dcd36b2e25035ec9b6ac8f0"
    sha256 cellar: :any_skip_relocation, monterey:       "2ffadbb803a343031c9579f03813d0f116150893a87dcde90480239baae42344"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6ddef5171a1455ebf3bf897b7b6e3dc4fc91bdea0b778b87de63ab6dc01ceb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f0cb0d260f51fe6234cc2451d8abe69b869f463a26cd6bd22221151a051612"
  end

  depends_on "gzip" => :build
  depends_on "coreutils"
  depends_on "python@3.11"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "--with-custom-env-python=#{Formula["python@3.11"].opt_bin}/python3.11",
           "install"
  end

  test do
    output = shell_output("#{bin}/ponysay test")
    assert_match "test", output
    assert_match "____", output
  end
end
