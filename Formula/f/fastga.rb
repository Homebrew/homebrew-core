class Fastga < Formula
  desc "Pairwise whole genome aligner"
  homepage "https://github.com/thegenemyers/FASTGA"
  license all_of: ["BSD-3-Clause", "MIT"]
  head "https://github.com/thegenemyers/FASTGA.git", branch: "main"

  stable do
    url "https://github.com/thegenemyers/FASTGA/archive/refs/tags/v1.5.tar.gz"
    sha256 "c12e8f54ff69f76e872a8878a5a2e68c4a7bce18f91e246d2e06b21871477a0e"

    # Backport fix for bad free()
    patch do
      url "https://github.com/thegenemyers/FASTGA/commit/6de7b91e6ee92ff3973af63255e51f08d9f77e35.patch?full_index=1"
      sha256 "3cf4c88286b7fe37fa3305c819b80aacb094da97cb30b8c227c62b7b79c0d1b0"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc7e3ef73e130726949e4e4634d3bd7aa78d1fb22c5fd9bde34123417ced18b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc1497b72cdebea582d06375aa7ececc525046644bf998556ca6079c059599aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24ad4e0719c6e0989bde3418e81a4d351ff23e777a031f097366a26b9134614f"
    sha256 cellar: :any_skip_relocation, tahoe:         "847abbd9f8a92a65c1a7deb3586a1d27a5f13d56979e5dab4ca0adb2ab60ee82"
    sha256 cellar: :any_skip_relocation, sequoia:       "8860922bfd9a0558b56ae0e0299d33855c97679e2bdc8a54b7fe884e262352cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "93ff80dce20906e24e09a813db8d110535e3e6c7ea7bfdd140023ab14dfb3d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af70dcfdb57ed0d5da744ff2b4e436eda1a41d0c0280d0f173cd78b711393091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "483d64fefe5df9f673614f9b122cd4326a3af4742780a03021ee3937cc1bce1f"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    bin.mkpath
    system "make"
    system "make", "install", "DEST_DIR=#{bin}"
    pkgshare.install "EXAMPLE"
  end

  test do
    cp Dir["#{pkgshare}/EXAMPLE/HAP*.fasta.gz"], testpath
    system bin/"FastGA", "-vk", "-1:H1vH2", "HAP1", "HAP2"
    assert_path_exists "H1vH2.1aln"
  end
end
