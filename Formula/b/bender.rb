class Bender < Formula
  desc "Dependency management tool for hardware projects"
  homepage "https://github.com/pulp-platform/bender"
  url "https://github.com/pulp-platform/bender/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "e7a0025f17e4949b57928ee04b93924ae74d771d2b808568ef44799cc7346929"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pulp-platform/bender.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fbd095e34b36f0f31eb7fb436ee152f651f53b06590285e43ed95a74694c934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca75ab9f4eea386a0b9e21301db16584ad051c163dc59c5429828499c382624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "185157643a016ee4969e0bd34b5b35d1b6303dd31272b0b5f45b650f34a1ede2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2a48857c7428b1fed8a75599851c24dcfa0026da0e736c968b1e5008026b3a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99236336d4af6bb519c014a72907c48cb4ffaeb7c63cb426d2f3db704382e33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24bfe7389c83af84936516e332a4a7687918dc655a7723f287e8ca98ce8833f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"bender", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bender --version")

    system bin/"bender", "init"
    assert_match "manifest format `Bender.yml`", (testpath/"Bender.yml").read
  end
end
