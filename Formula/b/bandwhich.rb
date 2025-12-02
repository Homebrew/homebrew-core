class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "aafb96d059cf9734da915dca4f5940c319d2e6b54e2ffb884332e9f5e820e6d7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceb7beda5d377f5fb16336a194d7aca4fe90fc7efa0acd996bc597ce55684da8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c15e7fef87ef65a7978559fbae64620eeb81447c7d36b75f61d7b38b7550d6f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7979b9c76cfc69fdc8a04c9d73d3e2eb971f80d97a2b001c0070dbd3b7f35a25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b3d6ba9e64f04836694b7fdc561898f574acdc7a9a16748c9cc7e3a55837779"
    sha256 cellar: :any_skip_relocation, sonoma:        "20cc25bd2086b5641e01ddab375f3c1011f53ca385cb19f8cfb4b46a46e5b878"
    sha256 cellar: :any_skip_relocation, ventura:       "960376206b857195c7d7c4640719b3e242fe1c06728eeb46ec441d517706fa7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8b780c7481b3b9c4e70cab919adb4d3e8784d03f1c8e0e9ba38d08d764012f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f381d378861391d73194970be1237864d4ef6acb6d508db75502da5981647d7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    out_dir = Dir["target/release/build/bandwhich-*/out"].first
    bash_completion.install "#{out_dir}/bandwhich.bash" => "bandwhich"
    fish_completion.install "#{out_dir}/bandwhich.fish"
    zsh_completion.install "#{out_dir}/_bandwhich"

    man1.install "#{out_dir}/bandwhich.1"
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 1
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
