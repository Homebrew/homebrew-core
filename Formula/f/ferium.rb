class Ferium < Formula
  desc "Fast and multi-source CLI program for managing Minecraft mods and modpacks"
  homepage "https://github.com/gorilla-devs/ferium"
  url "https://github.com/gorilla-devs/ferium/archive/refs/tags/v4.5.2.tar.gz"
  sha256 "5b4fde3eee2336c4874d8bf5c412e019843f9cef018f750bbb4c51c1fceb9484"
  license "MPL-2.0"
  head "https://github.com/gorilla-devs/ferium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48d1edbd3a10e386cfb072798460028265c3db1b7562a47b0aaba86e28f0f8dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79842b5b1deeed604eb5d28cbfd36dab19381412bc2c8445216e16a36d05aeda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4f94cf9739b46b6a30c6e91e3c278348240cfbe3ba0eb5985c86fa391dcd743"
    sha256 cellar: :any_skip_relocation, sonoma:         "21bc3aff757e77f165d4e9fe097714d80852e87413dd4e7a98ac396e0440a68a"
    sha256 cellar: :any_skip_relocation, ventura:        "0e41c29e31713d4521b7aae9f208eba590300ffcf8604384facf0f82e5b274b4"
    sha256 cellar: :any_skip_relocation, monterey:       "c8b68728e00cbf7ded6f3020acb9ceaf42e7b9588c7f06541f82ca7945879c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b610600dee374e6cafc8d8de657a21eb8e4e0fef77d583f2efedd9427e96dcc8"
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
    system bin/"ferium", "--help"
    ENV["FERIUM_CONFIG_FILE"] = testpath/"config.json"
    system bin/"ferium", "profile", "create",
                         "--game-version", "1.19",
                         "--mod-loader", "quilt",
                         "--output-dir", testpath/"mods",
                         "--name", "test"
    system bin/"ferium", "add", "sodium"
    system bin/"ferium", "list", "--verbose"
    system bin/"ferium", "upgrade"
    !Dir.glob("#{testpath}/mods/*.jar").empty?
  end
end
