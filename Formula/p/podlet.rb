class Podlet < Formula
  desc "Generate podman quadlet files from a podman command or compose file"
  homepage "https://github.com/containers/podlet"
  url "https://github.com/containers/podlet/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b91398ef75566a2a646e9845d1211854e7275fce727d4b976e7d8a3c4430ae52"
  license "MPL-2.0"
  head "https://github.com/containers/podlet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "37776de2f4d6b1a4089c86731e451ebc520751a7d794e757fb7020647c75de75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f333911ead765bc92f880d126fe26ff1c18b91b441d596e1f19c4eca8db6c4bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fc99a00efbb003102cb5857b8117438341e451e2cc3dfc3b896cae6923f4f33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e5797f123e7bbdca07b927e311c0eb0e2cb22dace9a7ce61cd644103a9c9c12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc64dddd79d76d64b4a3a2fcda7e0f22b9644e05f8a90486ed9b53911994ac55"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d4e1f96832eb6a64c3fb5a368aba8c11cbc863b0e273cd6bd12d0e3380f8389"
    sha256 cellar: :any_skip_relocation, ventura:        "fad99f8be93c835b25dab8cb0a206434bb07b94a5ef1fccb79123d2f9575506f"
    sha256 cellar: :any_skip_relocation, monterey:       "9ae49fd7b7dea4e064f75138fb5e816d1678897c36f869a4f31153999d63e968"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9968475ef2db45ac48ebe49bb425fe20b47f28895353b4de2f97634192355d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd73b27b073b7fc17d8e204cb4b62813e6bdfff78f9e6108dfec4a533232042f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = <<~EOS
      # hello.container
      [Container]
      Image=quay.io/podman/hello
    EOS

    assert_equal expected_output, shell_output("#{bin}/podlet podman run quay.io/podman/hello")
  end
end
