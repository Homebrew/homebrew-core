class DcosCli < Formula
  desc "Command-line interface for managing DC/OS clusters"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/refs/tags/1.2.0.tar.gz"
  sha256 "d75c4aae6571a7d3f5a2dad0331fe3adab05a79e2966c0715409d6a2be2c6105"
  license "Apache-2.0"
  head "https://github.com/dcos/dcos-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ce669ecdf711ee9694e40d12a22866fae9e14c59ac55436cc6284133c25b88d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "566aeb81f1c506438c9f5b503f775c540dfef7a4aa5e728e710e50a2e0c10993"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cf3b69223bb06a5b08f8f48eb320a2b45ef2fcf8e3f63c2e5fb49881872b7bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b7c3e8a7a0d91d84fd13cad41079bd7d718928b1acbaede6f7c5fc0f419b1bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f86f45ed4b5244b46a83cb5bf5bc5ac869dfbae3af926f175bee78a0ebd9b47a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d67f61c89ee09f845b39d1d44fdc61eac503144bf0da039bbd50fff50722c66"
    sha256 cellar: :any_skip_relocation, ventura:        "f467b1082fdb605f19a24bfa1b316f06a81e5f1c9dfdb2f522582e7d3c30ee65"
    sha256 cellar: :any_skip_relocation, monterey:       "26c6a023e4d2cf388c41f684d52f3d427f57d0a6eacd54a286c5f7c56efb7957"
    sha256 cellar: :any_skip_relocation, big_sur:        "1391a435f38b3a70514d0ef7f0a20f19a2d7027e64cad5c1b413730a89aaec4f"
    sha256 cellar: :any_skip_relocation, catalina:       "3f64db455d356a65dbb8be7bce2346b9b8afec968082bdad1efafb174bbde1b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "82c1abd40c451322835120c0c1ab9a8ffe507b0c7d55c77ffa78d995d9e6086d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ca96957a95df6e3084eeddf3d45cd52a26bdd69446647af7e52f297c6b1f1ce"
  end

  # D2iQ (formerly Mesosphere) has shutdown last year
  deprecate! date: "2024-07-07", because: :unmaintained
  disable! date: "2025-07-07", because: :unmaintained

  depends_on "go" => :build

  def install
    ENV["NO_DOCKER"] = "1"
    ENV["VERSION"] = version.to_s
    kernel_name = OS.kernel_name.downcase

    system "make", kernel_name
    bin.install "build/#{kernel_name}/dcos"
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=#{version}", run_output
  end
end
