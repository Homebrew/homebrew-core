class Kiesel < Formula
  desc "JavaScript engine written in Zig"
  homepage "https://kiesel.dev/"
  url "https://codeberg.org/kiesel-js/kiesel/archive/0.4.1.tar.gz"
  sha256 "a21430c087ff0089dc52de038e5124fbac8e981ddb11d98c1e205e70e5acf4c4"
  license "MIT"
  head "https://codeberg.org/kiesel-js/kiesel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b050d26dc4426b4b2455d46a36c79865a8dc7fbb17ca10f3dea17d052f64105"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e5acb716e8f9d174d1c96e3280fca4a76fa9b4da336d5a4d9cf125d4e8775ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0902edf986a74f4d485b205a813afd9da2a9879deafed1cc203a2d44413e1032"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "367d6938dab9462e9a3566aad497f7d63afecd2e9c74eda28cef2e182838ccf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f00faed32bee27f6a69425499b24a0108a7cc7370d07cb0a8097b3e1922723af"
  end

  depends_on "rust" => :build
  depends_on "zig" => :build

  def install
    system "zig", "build", "-Dversion-string=#{version}", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kiesel --version")

    (testpath/"test.js").write <<~JAVASCRIPT
      Kiesel.print(21 * 2);
    JAVASCRIPT

    assert_match "42", shell_output("#{bin}/kiesel test.js")
  end
end
