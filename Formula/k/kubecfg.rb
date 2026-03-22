class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "0f135465c512f8d5017f30f595669bed6a1c65b39b10178ede6989e15cbc84a9"
  license "Apache-2.0"
  head "https://github.com/kubecfg/kubecfg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dafc40beef50da4e6258e2650d4e74d9038b8b47ac36d607937c2ae468d1e682"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d7373d5b92e6d7fa40d26f346278f9946d7ddf773c8312ca49b1e13d06a85df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "895b4c9f01632ae07409dee040f42fb73ee784a6726cdfbcf22bced5beeb3718"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0910ce4d7d1fe0cedfa2c3947b21e1b53a88a863ccbb97e42dafb05abccc12f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "afcc53d1d2bdae49341594f9eaf3741194d1ba7b918a4a65aa21ef4ba39e5110"
    sha256 cellar: :any_skip_relocation, ventura:       "f693e55e6ca8a34c770b67807e92969817a2a4ee015c84d07057285779d57249"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03813301e8958ac9dfb657e548d38d919609aef21593df3bcc9917adccfa27bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b82e88d3134489324a448c33bed9315a57878b9aab5b2508ce678a6e2be31a5a"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "kubecfg"
    pkgshare.install Pathname("examples").children
    pkgshare.install Pathname("testdata").children

    generate_completions_from_executable(bin/"kubecfg", "completion", "--shell")
  end

  test do
    system bin/"kubecfg", "show", "--alpha", pkgshare/"kubecfg_test.jsonnet"
  end
end
