class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/docs/getting-started"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "30875dccc05532feadb303ce7ed62a6c60edeec8f845d9dfbbb28fd0999acdf4"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eedd1a09acbb96bb9c2fb175c4994f81c1902e72c33373d9da068d0fe81357c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31bc4fee9e4281622fc99cd6577cfbdf298f3d817e7e95c51df750d0ede11dfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e46f642ea2688a6e4277742e5f42868e540122fb30bb8c2b5e93ed26fe2d4b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "534bb53b7469db36b5ae82091c33d748881a2e16ebe6a9e2bfa57a526c1219c4"
    sha256 cellar: :any_skip_relocation, ventura:       "5b71fe1745d0b7fe37e49aaae5cb74864c0a92e4fc89a79ca0d12f86c2ac217e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84df56f0313366efaf5a8a2eb70aceba5927ad770980846e3a99de06fcaf197b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a8ee9b25b9fb95444882f64db565ac796a50f58e046f26cb82de11fe97615a5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
