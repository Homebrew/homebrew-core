class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.14.2.tar.gz"
  sha256 "98fff2b7122dac8b5dff9ab9a795c86dcfd2f9868ca8e33826a78f6567825ce7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce669f40c64b4330a71d744165089024a4a4e2e677078361e1c91f1895fe8777"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "466f40314b3fa3a7c5dc704356c40f683d242f770c775b1850569ff462719941"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e493ed02409d1db6445e710e35882fd31668ded7b72e73ca50373eb9f2cc870b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2e20e057371ec398746c3e9f96c2a260075a49b155da31abf472fee475b947b"
    sha256 cellar: :any_skip_relocation, ventura:        "539b055c2bf349d224e05814fe78259ce31b00b6f6d7c7345bcdba73675e6b10"
    sha256 cellar: :any_skip_relocation, monterey:       "6777db6830411a69783b3aaa359f352547e5ee34d4ec275dad75b079b0aef301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ed18670efc51d0ee486d50fb5603c206498052006a7079f365eb6e0db814670"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev --yes 2>&1", 1)
  end
end
