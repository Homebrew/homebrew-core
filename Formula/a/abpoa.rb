class Abpoa < Formula
  desc "SIMD-based C library for fast partial order alignment using adaptive band"
  homepage "https://github.com/yangao07/abPOA"
  url "https://github.com/yangao07/abPOA/releases/download/v1.5.7/abPOA-v1.5.7.tar.gz"
  sha256 "9c5e7649a4268223ef1fec0318b3f4fa7c118ffa2daac124051c7961e6894bc8"
  license "MIT"
  head "https://github.com/yangao07/abPOA.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7754fce45bd7a37b567741016605492e9b3e94db53955011a308cbab011bc22c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd232c10a127d10f27d2f7e427bc35bfd8c2fdad4e5f817848538f7e4d8c1207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "acd3292b288e7154e4db5a9c8fb02011f0b946b60424277a806f5ee2de66e8d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "43416190587993099b4dba1c40ebbd3aeaada41e5c9bfa9eed184aa3d28a45ce"
    sha256 cellar: :any,                 arm64_linux:       "02d4af5c4469c0c392c37f6fafd14fb3b8f1862517b0bd0b5ade4484598e5c3a"
    sha256 cellar: :any,                 x86_64_linux:      "d2adc2fbf775e089aa49c78776516a8df09eac24ed849b7a5b68f8049747d07a"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "make"
    bin.install "bin/abpoa"
    pkgshare.install "test_data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abpoa --version")
    cp_r pkgshare/"test_data/.", testpath
    assert_match ">Consensus_sequence", shell_output("#{bin}/abpoa seq.fa")
  end
end
