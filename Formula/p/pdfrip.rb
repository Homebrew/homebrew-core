class Pdfrip < Formula
  desc "Multi-threaded PDF password cracking utility"
  homepage "https://github.com/mufeedvh/pdfrip"
  url "https://github.com/mufeedvh/pdfrip/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "60f284d79bac98c97e6eaa1a2f29d66055de5b3c8a129eb14b24057a7cb31cd3"
  license "MIT"
  head "https://github.com/mufeedvh/pdfrip.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1036db7676a0822b721390e43e797e7e846dbd3b4f0c35acc3fb71fee338f938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68c75d4a427d4512dce141506acc4d3b02e8640d3fb54a30bfc0c9be4ffa525a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeac32a01baca1d879c37adc93518653405ffc1437ef2551eed0d7bee45a9c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "b27b773f78bba7b8d64b60cc5c8b8cdef12d45574be2d4881223bace41d64acd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0db2c8b883091a68cdda3fe1f4da41213bd041fbe8b93862b86e744baa60c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8fc88b6d291c32c7e3b0ed9fdda602f2a237e8478921f07b56bf550dbcbbde"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  # Fix to build error with `indicatif`
  # PR ref: https://github.com/mufeedvh/pdfrip/pull/64
  patch :DATA

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfrip --version")

    touch testpath/"test.pdf"
    output = shell_output("#{bin}/pdfrip -f test.pdf range 1 5 2>&1")
    assert_match "Failed to crack file", output
  end
end

__END__
diff --git a/Cargo.toml b/Cargo.toml
index e0db059..6cdba04 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -5,7 +5,8 @@ edition = "2021"
 authors = ["Mufeed VH <mufeed@lyminal.space>", "Pommaq"]
 
 [dependencies]
-indicatif = "0.16.2"
+console = { version = "0.16.0", features = ["std"] }
+indicatif = { version = "0.16.2", default-features = false }
 log = "0.4.19"
 anyhow = "1.0.72"
 crossbeam = "0.8.2"
