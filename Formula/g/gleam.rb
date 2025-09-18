class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "5ea236d1eacbdf06922f99fc2c06acb0fb50c7dae713ac3106b9fabd51744a7c"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "765d807ca291cf314d321b366b47327ff9914a0198e5d229aba23ce4825261d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d60988072de1ce74dc0366af7da835140365cf9dd7128a01be2197ee8cb08260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75b719c2491cc44aef0ad099e939c7bb2ab99397cfe28c703f1f992b60a13ca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d45c964b7a221b30f2dc568e9927faddf57207a9f17a82c7219b6b7535386b1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce9742e971ab7e19e766c646811fa562f073097b738cef8599794661ea6011dd"
    sha256 cellar: :any_skip_relocation, ventura:       "bf67a8eb8254b7be68375ab3056b4d705d956b3329ecd3cff660a1d8ce30b9f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c871c16c0c2a625640ddc04eb7340839ab9524083ed6074ce181e37107197c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e98b2669480dd7ca3fe849f17684ccb9dd13ab3d0f94d822c2fe405b1e64ea6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
