class Odinfmt < Formula
  desc "Formatter for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-06.tar.gz"
  sha256 "f8055ff723994dc4debc02817c230d0173c43a23df4a9d6a7104fea69bfeeb79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70212865ff66f0eb72108f544a25a3b64d8e0a2af528b5e0a4c2c44cd037c5e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "694aa4720fa63d283c888ad3c61d2a70d97c05c688e4b7eb3070124ec091c77b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c37a99961d1c0ab1683686d19000328c296203c49cabba8358c3ef60d7722769"
    sha256 cellar: :any_skip_relocation, sonoma:        "c248288c86226f43e619f824708c863a18fbc5ba8011bb675f4c5e40f884596c"
    sha256 cellar: :any,                 arm64_linux:   "68f2b89d834ff871430a4d50c72f07dcda67adc3d869c703cb8ae769812b13cf"
    sha256 cellar: :any,                 x86_64_linux:  "65e34abfd7ddc0e91b8af794ecc710bc289077b9aff4837b7f1cb0f24a067df3"
  end

  depends_on "odin" => :build

  def install
    args = %w[
      -out:odinfmt
      -collection:src=src
      -o:speed
      -file
    ]
    system "odin", "build", "tools/odinfmt/main.odin", *args

    bin.install "odinfmt"
  end

  test do
    input = <<~ODIN
        package main

        import "core:fmt"

      main :: proc() {
      fmt.println("Hellope!")
      }
    ODIN

    expected = <<~ODIN
      package main

      import "core:fmt"

      main :: proc() {
      \tfmt.println("Hellope!")
      }
    ODIN

    (testpath/"hello.odin").write(input)
    output = shell_output("#{bin}/odinfmt hello.odin")
    assert_equal expected, output
  end
end
