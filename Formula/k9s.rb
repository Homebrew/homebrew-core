class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.23.6",
      revision: "ed1d7fbda5fca37800e452f4628cd25958559fb1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "866dfccbdf80c07575c9cfe382d61c14f75d12e9477c77ff79c3b3e97db6634f" => :catalina
    sha256 "f70a4a17a89d273733679884590067399723256de6c0c170fd26f6a3b253eed0" => :mojave
    sha256 "f342c4a8079f6bb8032bc2c055f4e45c255c0dc52c98d38fd42c1c97e32a5cf8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{stable.specs[:revision]}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
