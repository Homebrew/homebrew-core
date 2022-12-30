class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/v4.3.2.tar.gz"
  sha256 "f76b0b57274dcc2499fb83cf329fafc888b5c591e8078f09b01c82a21834cb18"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "797c33572129fede3edda585db4bbe9c08338bc1141d920f9f6d5a8ac6446ecd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af47481d04cb9ed332d92316dfd5cfa62ef00de42735a07f62204399ba4d32ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae188a1e701f6d3ebe1ddca776136a793fecda48c7da27cde5589168d9e1c221"
    sha256 cellar: :any_skip_relocation, ventura:        "7a802f872230ccf526f90e21f0eeff43df07375aa00cf1214832314eaf0cfde5"
    sha256 cellar: :any_skip_relocation, monterey:       "4f89cec8ad7350b683195a5adc97f40feaf15b7159eed99dd8899826c6c5354d"
    sha256 cellar: :any_skip_relocation, big_sur:        "10ad5f52e3dc7e9a4fbe7836427728cfe8f2704440557b1bf3afa684ddcc0823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a600b68ff1a260651b01614c1e3d9b6d1164961c5c899d5bb8e4e1d6f51a89cc"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ferium", "complete")
  end

  test do
    system "ferium", "--help"
    ENV["FERIUM_CONFIG_FILE"] = testpath/"config.json"
    system "ferium", "profile", "create",
                     "--game-version", "1.19",
                     "--mod-loader", "quilt",
                     "--output-dir", testpath/"mods",
                     "--name", "test"
    system "ferium", "add", "sodium"
    system "ferium", "list", "--verbose"
    system "ferium", "upgrade"
    !Dir.glob("#{testpath}/mods/*.jar").empty?
  end
end
