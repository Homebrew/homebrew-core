class Headson < Formula
  desc "Head/tail for structured data"
  homepage "https://docs.rs/headson/latest/headson/"
  url "https://github.com/kantord/headson/archive/refs/tags/headson-v0.17.0.tar.gz"
  sha256 "9555186f0f79a8be725aec6a3d857ae6d2b58133e060b0b7eeeeb85715284dbf"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d8ce3e6d998c955d7819e17e0f091dceae9fa2e5c1f541d3e4b46ae0e1a3c1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f21f5f403200e2269de1cf4ee2b93388656d160df8f4a6cb04e3b7f64b0e0016"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1227919cf32dce3b14d1c881a51988bb520aa191bf2be90d4bd39cf518a4384"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b8e98f972736400a8ac451b6f1d64e9ae8c40cf87cd4a14e7a439287dd4f1d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e389b41d5fa7b9e5dd88ab534eb0688e42643a50ae0bbb7166a70f4094e8fff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2795200cf1d329878a562f93f5fb07a4c45f90b6f56d99343d143faf9a5a26c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hson", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hson --version")

    (testpath/"test.json").write '{"a":1,"b":[2,3]}'
    assert_match '"a":1', shell_output("#{bin}/hson --compact #{testpath}/test.json")
  end
end
