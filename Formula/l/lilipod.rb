class Lilipod < Formula
  desc "Simple container manager for OCI images"
  homepage "https://github.com/89luca89/lilipod"
  url "https://github.com/89luca89/lilipod/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "e1f8f94659d64fe06ae22e43c09fdedbdbddb88eb62897c4df44cd2f996d4e00"
  license "GPL-3.0-only"

  depends_on "go" => :build
  depends_on "wget" => :build
  depends_on :linux

  def install
    ENV.deparallelize
    system "make"
    bin.install "lilipod"
  end

  def caveats
    on_linux do
      <<~EOS
        You need "getsubids" and the "newuidmap"/"newgidmap" helpers installed system-wide
        for rootless containers to work properly; install them with your distribution
        package manager (for example, on Debian/Ubuntu: `sudo apt install uidmap`).
      EOS
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/lilipod --help")
    assert_match "saving manifest for index.docker.io/library/alpine:latest",
                 shell_output("#{bin}/lilipod pull alpine 2>&1")
  end
end
