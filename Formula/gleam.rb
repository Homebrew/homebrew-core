class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.15.1.tar.gz"
  sha256 "6051e54c62d77ecdf1e355c5a75c51d9e049224710de0007357742d8ba947149"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5026ba2b6ccb76f2706dc20998bc695ca142cb4d37dd84dc43a25f47506a4eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "5cb82671ad74bf2d9d0ef35fb64f0875f568dec5054f5b30a57db4029e3da9fd"
    sha256 cellar: :any_skip_relocation, catalina:      "886edf156c5bc084f7ea488d278468bdb6449e78ea0f4dc10c632bd56cdf7c02"
    sha256 cellar: :any_skip_relocation, mojave:        "5159e973342ed40e3c717d3c65e6611e25fba6198acf380b9377cfdda9b59021"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
