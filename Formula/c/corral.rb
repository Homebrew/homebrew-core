class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/refs/tags/0.9.0.tar.gz"
  sha256 "7da78ceb96338b746e3c28ad16454d86fd30da576fa66e8489d781311fd1983b"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "262882a485d75653fe712782ce3a6a7549b0cff09ce0194b7694ad5e9f5629fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca70a8407b60091e292c9e4a4a87eb6e99223b2a77a3d4eacdbc266b3c6e68f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b72cbd12bb1ab538b5a248447a80f347c32f27b080e0c319a6f2e085ac090be8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "419d53d57549fbe043f3d2b6cfd5218bfaa5cd90f68f9008ed5fcacfee7ae894"
    sha256 cellar: :any_skip_relocation, sonoma:        "302e3e94dbda399084f2bfc722c5599c9e1cb33b25008a5c25cc3d4229975b5e"
    sha256 cellar: :any_skip_relocation, ventura:       "9574ca600bd03323add5967beaf3d5725b0cb56f5d7f63dc631ef0e140e0cadf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6974ea725f2dceb7d0a07970485b9c4adc614950541c4be3be9b3631f8ef4dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6f801892caef51faa6d39a3efd96262d11469b3a44216253e7238b70149826f"
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin/"corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
