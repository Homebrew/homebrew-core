class Alass < Formula
  desc "Automatic Language-Agnostic Subtitle Synchronization"
  homepage "https://github.com/kaegi/alass"
  url "https://github.com/kaegi/alass/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ce88f92c7a427b623edcabb1b64e80be70cca2777f3da4b96702820a6cdf1e26"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "de4af244ed90c2a2b9c309340cb5d47e926ce1f2012001524d1674dd4213b1fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "efa1a388ee9ecf5193edd9c9003af0f035ed138bf6a79b45e6b22654c32888e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f42a7b7ef244c6018d9d16f3979f14758ca54a50a568b269011f9ccdcae5f39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93ea3d2535b7d2f339a736efbbf28f952abf06fdcb8186a72b1f706a77c9c3c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c20460b0e920c4165d4f2e0fda02055564277562ca0707d7417279f3c1a70a4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89d96baa88517ace085a0a467f08928fff9fc15966edd7061ebf614133eb5e98"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a5668b9a440fb7cf6b8827824abcffd57d69473c2c55749a303e460dade07b3"
    sha256 cellar: :any_skip_relocation, ventura:        "1b6e4cc531bc410f1c4792f5e8709230fa1312425499c7179712714ecbfbc593"
    sha256 cellar: :any_skip_relocation, monterey:       "3b60c7670145e819679d32671912305e150b55164de74e39b4ea788586651696"
    sha256 cellar: :any_skip_relocation, big_sur:        "8aa09d2f899a21272a4703e587a036e475b4ce060bdb9ef0d214b449157126fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dc47c934ca68489561b3f325fb9627fe7cd98d2cbffb0bca6bb1d4bbb0c9e0b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499c4ee6c9cefa90b135dbfb668879f8a56fd5da4ab20dfd077ae1047b34f0f1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "alass-cli")
  end

  test do
    (testpath/"reference.srt").write <<~SRT
      1
      00:00:00,000 --> 00:00:01,000
      This is the first subtitle.
    SRT

    (testpath/"incorrect.srt").write <<~SRT
      1
      00:00:01,000 --> 00:00:02,000
      This is the first subtitle.
    SRT

    output = shell_output("#{bin}/alass-cli reference.srt incorrect.srt output.srt").strip
    assert_match "shifted block of 1 subtitles with length 0:00:00.000 by -0:00:01.000", output
  end
end
