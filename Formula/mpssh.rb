class Mpssh < Formula
  desc "Mass parallel ssh"
  homepage "https://github.com/ndenev/mpssh"
  head "https://github.com/ndenev/mpssh.git"

  stable do
    url "https://github.com/ndenev/mpssh/archive/1.3.3.tar.gz"
    sha256 "510e11c3e177a31c1052c8b4ec06357c147648c86411ac3ed4ac814d0d927f2f"
    patch do
      # don't install binaries as root (upstream commit)
      url "https://github.com/ndenev/mpssh/commit/3cbb868b6fdf8dff9ab86868510c0455ad1ec1b3.diff?full_index=1"
      sha256 "c91c3478f05de4b3c200a384ca28449d0c43ad569e8035b3b5247c787f0a984b"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e37b5e479ba7f9ad86373e646c63485b55dd1381c2cbc130150e108886675b72" => :mojave
    sha256 "1057c47b866d50031a23a0bd244d3bc056b9f12a4d9bf0aeebc0ea292c484638" => :high_sierra
    sha256 "90d758a0f7accf0b63755c3de8100a880b500e732fc8924123ab2a1c7ce688f8" => :sierra
    sha256 "e5ac485861dfca0be2bb1ca2eb5826b5ca5977c0d2abb12dc58de011c18046f1" => :el_capitan
    sha256 "2b91c9a9dbae19e99b8b8735bb3292cc056dcf8e06472c0b2d354f64896a4186" => :yosemite
    sha256 "60d489a872cb7ed8855c0f95913af4fffe3082b6bee8669b0080c3d30d73249d" => :mavericks
    sha256 "a528ce8c03771e3366f5380b18e2a43aba6283e09bb8945234c42dc25116cf41" => :mountain_lion
  end

  def install
    system "make", "install", "CC=#{ENV.cc}", "BIN=#{bin}"
    man1.install "mpssh.1"
  end

  test do
    system "#{bin}/mpssh"
  end
end
