class MacCleanup < Formula
  desc "Cleanup script for OSX"
  homepage "https://github.com/fwartner/mac-cleanup/"
  url "https://github.com/fwartner/mac-cleanup/archive/1.0.2.tar.gz"
  sha256 "52c454c9abac16801814a90d766ff1d7367a698b0e003bc3dfe02cdfde6d1fa6"

  def install
    chmod 0755, "cleanup.sh"
    bin.install "cleanup.sh" => "cleanup"
  end

  test do
    system "#{bin}/cleanup"
  end
end