class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://github.com/ignite/cli"
  url "https://github.com/ignite/cli/archive/refs/tags/v28.7.0.tar.gz"
  sha256 "d0c0c8d4a47fd62651bf5d5883a2fdbe639b474f4794c84c0539aaffc0c4cdea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d6503cc00e4b89cbb5484f0695c279d4bea5ba3a811c4f33ced25d027d6314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "241525cfd415e47297398bfe9ba5fb4f34e801c7ba2421c48895cc2ce00a92cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22d6319032562e9bae281c298b89d80589dffc8331d8c8634790678ff28c282e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8432f2f42d410c6bc89b6f51991afe79f49a92b99fde4e7f762d60c4f97d639a"
    sha256 cellar: :any_skip_relocation, ventura:       "8a6ad13d7d98f97433ba6368518ab657622833a47481335cb57114b5a9f0f496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15b2781aba0def209f7962feeb1117d28a3268244a1ffcfe87fb0196e0bdd511"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    assert_predicate testpath/"mars/go.mod", :exist?
  end
end
