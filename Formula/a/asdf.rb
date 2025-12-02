class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "c452a886503277260b7c82c07031800340f892bb2147bb3af67dca7268a410b5"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b22b8e329c938b0b7c464de089c396e48c8712c8ea34df5130dc6f1652883616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae721d20a3a3f9402d2bad6201a001379adcc3300c01a4548fbb5067daeee338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae721d20a3a3f9402d2bad6201a001379adcc3300c01a4548fbb5067daeee338"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae721d20a3a3f9402d2bad6201a001379adcc3300c01a4548fbb5067daeee338"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bc472f55318b4b9810673f11731f42338e6ebf466cd4098426e0d72b483dd6a"
    sha256 cellar: :any_skip_relocation, ventura:       "6bc472f55318b4b9810673f11731f42338e6ebf466cd4098426e0d72b483dd6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "884f05b0a2dd2c2e377fb8f9c0ccd7070d1f499175fac67544d99f4df5e75e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f6863a8bc60de461a3228c19198f8c927bac21c4e17618a8c28d22ccfa7675a"
  end

  depends_on "go" => :build
  depends_on "git"

  def install
    # fix https://github.com/asdf-vm/asdf/issues/1992
    # relates to https://github.com/Homebrew/homebrew-core/issues/163826
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/asdf"
    generate_completions_from_executable(bin/"asdf", "completion")
    libexec.install Dir["asdf.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    assert_match "No plugins installed", shell_output("#{bin}/asdf plugin list 2>&1")
  end
end
