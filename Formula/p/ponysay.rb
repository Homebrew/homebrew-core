class Ponysay < Formula
  desc "Cowsay but with ponies"
  homepage "https://github.com/erkin/ponysay/"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/erkin/ponysay.git", branch: "master"

  stable do
    url "https://github.com/erkin/ponysay/archive/refs/tags/3.0.3.tar.gz"
    sha256 "c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a"

    # upstream commit 16 Nov 2019, `fix: do not compare literal with "is not"`
    patch do
      url "https://github.com/erkin/ponysay/commit/69c23e3a.patch?full_index=1"
      sha256 "2c58d5785186d1f891474258ee87450a88f799408e3039a1dc4a62784de91b63"
    end
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab0fc5205ff5d90e766f69e722c887b690ab68caa3d8c1c5f761362f39487eda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce90b90f2442f9fb488ed6d6e01e2a054baa6028d0da97cbd26e74f608877791"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d412af3a212b5e3535e7832aa0c6d64a37e1271715ca89db5e56a56d2b8717a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a399855bc086848892024a1480ac18e1b53d5a53c2b8bbb472779870bceb92cc"
    sha256 cellar: :any_skip_relocation, ventura:       "2ad3b739716124c282a0d73df44ca1423865feb2afca9c01d1ef8783b33dd57e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2504c83a81ba25e6eb424014ebb4056ad61f9e7fa5090931a14920f1542d20f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f37044f82a22ebc8480e11efd3c0a17934acebcc2cbc304b2f5c43a4a15843"
  end

  depends_on "gzip" => :build
  depends_on "coreutils"
  depends_on "python@3.13"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "--with-custom-env-python=#{Formula["python@3.13"].opt_bin}/python3.13",
           "install"
  end

  test do
    output = shell_output("#{bin}/ponysay test")
    assert_match "test", output
    assert_match "____", output
  end
end
