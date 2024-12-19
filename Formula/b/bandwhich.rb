class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "aafb96d059cf9734da915dca4f5940c319d2e6b54e2ffb884332e9f5e820e6d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79b7039407c45b9ae037ea6270d4ea7b4f20a7ec4ffb226ab6ad6f3dce5aa616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab4add3f83652c95f27848cda6d3f704736afb00a841f6a55d63ce899c439c8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59dd515d7febd74edd9b41df776eee76225757791f0caa85bbc0e382d8bcad49"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e05307ae4dd2ac11be394a1f37c4fa6bcfb0d6bb12cccb528c8d011f3001f4b"
    sha256 cellar: :any_skip_relocation, ventura:       "cc0bcdf58c071af9821ad11e331838c904385bf663bd560ae1f0f2db8939885d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf3323a093b191a9b281315882dac416fc849866214b99855f29534d27279d5"
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
