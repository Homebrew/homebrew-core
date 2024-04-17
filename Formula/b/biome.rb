class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.7.0.tar.gz"
  sha256 "6315e74e7c09547e453ac8fe1071b4bbeab0638fe9986898c59e8d497b8845fb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b16e75b44b7abca6296b8391f5a42fe918cc15483469618014352a88c3848cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8443cf193974e27121400454484885fabe95e8af8f80b0cee340bef51c7e8af1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "121de078df34b2e2fc653b102593ec0c3e0b2aa648621d0fbb2fb549253f1220"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4fb5493846b5a10177cdb4ae1af559f199b1209ac79dee768c1cb1b4e8e6d16"
    sha256 cellar: :any_skip_relocation, ventura:        "d5a966329c03d83829266265f19f4bb91d74a471da21cf198daa4c8ec4eb04f5"
    sha256 cellar: :any_skip_relocation, monterey:       "0d67e7b968be7ff55ff6b137aa079610831e92ba64b6532e2b12455d252aa795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "938c1f5bb2424e09590d084f09fbf0f657bf78a60977ae14543b71a4458ea969"
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
