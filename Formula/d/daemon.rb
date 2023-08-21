class Daemon < Formula
  desc "Turn other processes into daemons"
  homepage "https://libslack.org/daemon/"
  url "https://libslack.org/daemon/download/daemon-0.8.3.tar.gz"
  sha256 "bd6fd870ca4761f43f045d72db0f8a0de81a3eac07264bf449b152d7dd899ac0"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?daemon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a5baeff9a97593e7a29b182b74c92a27d86538b058d24eff3c6d30e05240afa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12090499c8e437515b8dde21f47c00f401e1d3988e8bd7db9ee8d8a3f7778142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ff12c5df6b267ccd13f8726cb7f991c1b2baa2c24d68aac53eb216a23ff4ba7"
    sha256 cellar: :any_skip_relocation, ventura:        "dc74dc5684591db1fc2c1a0284a6ff976733c1655c4d51ceb81a86959ee573fe"
    sha256 cellar: :any_skip_relocation, monterey:       "e1b683bc98f5b9ba58b3f5ac8617bb3edbb88dfc74068c9ee038a17395853130"
    sha256 cellar: :any_skip_relocation, big_sur:        "04bc3084255d0d5337b8cefcb4a535adb791a2dad19b783a3f244a716ef773e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23a9a59bb5045562e80171f3b0f7f9511b393759e44bfa903af4a9c83c81b472"
  end

  def install
    system "./configure"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/daemon", "--version"
  end
end
