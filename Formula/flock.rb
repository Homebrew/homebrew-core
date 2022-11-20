class Flock < Formula
  desc "Lock file during command"
  homepage "https://github.com/discoteq/flock"
  url "https://github.com/discoteq/flock/releases/download/v0.4.0/flock-0.4.0.tar.xz"
  sha256 "01bbd497d168e9b7306f06794c57602da0f61ebd463a3210d63c1d8a0513c5cc"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37a4abe9f2dc5ad5297a5dfdcb10fc1aeafe587b06a7a275231d05a3dd48b572"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a65c4619ce6f133e7a5b9e82d7648b7da9ace48a09f89d69eb66f38bd6e2b6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d6b63e6990f0bb2509aa01abc38208de8d809446fa32cd86961dec0aaffae4b"
    sha256 cellar: :any_skip_relocation, ventura:        "0b28bbaccdc54d4f0bcbc960731cd45dad2dd3538bc24f5e728e0ef0defa4a33"
    sha256 cellar: :any_skip_relocation, monterey:       "ec7c9523be673e50dec3b6aa3d17ef4905076e0f804e9ebccbca128bbf8855c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f9fc94a66a10a05c005b8043b477fe5f8ec4c995efbc853a9d56c541370ac97"
    sha256 cellar: :any_skip_relocation, catalina:       "b781487b76eed046d9e7c5d2db71a7c81001dc6b80926b9215bc7cb4e7a3c162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca5c17cfc66b0b2589e07c696cfbe385addb1ed8905c5d851d64b2dbbee00940"
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    pid = fork do
      exec bin/"flock", "tmpfile", "sleep", "5"
    end
    sleep 1
    assert shell_output("#{bin}/flock --nonblock tmpfile true", 1).empty?
  ensure
    Process.wait pid
  end
end
