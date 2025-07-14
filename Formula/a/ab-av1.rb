class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https://github.com/alexheretic/ab-av1"
  url "https://github.com/alexheretic/ab-av1/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "837c3016f6eeca3ea174bdaffcc9bb29cc4917a05f43367579b8b0d7bf68db15"
  license "MIT"
  head "https://github.com/alexheretic/ab-av1.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "054d32abb5e30883eba42437e7601f94b610c07fadfb3f843bb8a356cd4ff499"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93f75abbb34e3f11dc8b0102517d5a9769abf26e384ce0aa59904ecb5c78894f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8da4a26639bf8f8adca062321bbcae7452b0953801ddc89153bd06113452c921"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cc6fffb9863658595610461339b5e5a07fe4f8b3531f7e058442213d803b286"
    sha256 cellar: :any_skip_relocation, ventura:       "1c58bf1d5408deffa4bdf5f1adb0de0cbfec33429d926efd9f4838fad5dcdbcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aefe876ee0c4dadad0ab3307481d6f62e6d4f91a1d1ce93baa5b6a23329fbcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "070168c14a60daebc173c5f5ad49a8ecc1b0a81c38fef8c0ea601abf6ff60e2f"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ab-av1", "print-completions")
  end

  test do
    resource "sample-mp4" do
      url "https://download.samplelib.com/mp4/sample-5s.mp4"
      sha256 "05bd857af7f70bf51b6aac1144046973bf3325c9101a554bc27dc9607dbbd8f5"
    end

    assert_match "ab-av1 #{version}", shell_output("#{bin}/ab-av1 --version")

    resource("sample-mp4").stage testpath
    system bin/"ab-av1", "auto-encode", "-i", testpath/"sample-5s.mp4"
    assert_path_exists testpath/"sample-5s.av1.mp4"
  end
end
