class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.2.tar.gz"
  sha256 "07712e7a88de97badd6cf1353abc4c5555d48632a46b25aeabaa5d921d8ff3a6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b5a933ff6d9630c3eebe1ef8a0a6451ec41b7e8c0100495dd09f6dca44ea87f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a41c0297b564dadadc1cb1b6f1362687887a102516979b57150d41b4eb20fca7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2497c9ee1e4d28efd3d7c3335f50428bc57be677bf6d0c4a4898bbce5064d186"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8358a50d771cfcd09aa92ba7f0438d702c188599a006419edfabb3347d68002"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908cc461463d7e4dbcdaf7bc6fbf8fce4af54465fc6f7a1c710922956b53ca6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9562a4781a01b7de0588882166a637f49cd685b99b1b49180e471eadb65268d"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end
