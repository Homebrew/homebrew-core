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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1eca8b3e7cdcdcce01318a2d876e56ddbee396f5743a86505ebf10890495bfed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d372bd35d2c931e62724cd071813731b6d2b7ed218c2b97ea22d0ea3b21e270b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a04a741432a0b11230d1fd4a166e21124560fcbedd9d342871c7fe94262cef09"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ae64325c0fc4bcb425a922a9313ff2f965d79f8cb7f1efe3dfa3bd09866027f"
    sha256 cellar: :any_skip_relocation, ventura:        "f5d7684b1337c8cbd02fb95bb5053fc7976dbedbce2af249fb7edb797e3fb7c1"
    sha256 cellar: :any_skip_relocation, monterey:       "0bcb34fbf82236dc5e6fe5483c0e92920285e9bb9e8852ce23640281d1af6320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "511bcb624a5d9ffe092b33037026376eb3fc2f93c221776efacf32a2a2d7fd54"
  end

  depends_on "gzip" => :build
  depends_on "coreutils"
  depends_on "python@3.12"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./setup.py",
           "--freedom=partial",
           "--prefix=#{prefix}",
           "--cache-dir=#{prefix}/var/cache",
           "--sysconf-dir=#{prefix}/etc",
           "--with-custom-env-python=#{Formula["python@3.12"].opt_bin}/python3.12",
           "install"
  end

  test do
    output = shell_output("#{bin}/ponysay test")
    assert_match "test", output
    assert_match "____", output
  end
end
