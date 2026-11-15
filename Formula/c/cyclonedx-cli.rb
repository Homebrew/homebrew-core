class CyclonedxCli < Formula
  desc "Tool for analysis and manipulation of CycloneDX SBOMs"
  homepage "https://cyclonedx.org/"
  url "https://github.com/CycloneDX/cyclonedx-cli/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "01574e2e7d1cfe88ed50bbe7e87663af45a6b261ba11518a6c8eb34f809e1309"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e60d340729ff074fdea36fe60af23b8b48d2913cb262f7ae6191334936ed727"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fccebcfc177e5593aabe03abfc950a9887118b868113f1fb87fc73f929bc9aba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87099c60d6548f5fddf1899e73fbaa669620d16132591b8fdd0672d9b00f8983"
    sha256 cellar: :any,                 arm64_linux:       "5114aded123a330ee216546ab7351b3a023cf3b8f77ce933335b5995cee3b98f"
    sha256 cellar: :any,                 x86_64_linux:      "1191a27a3dae32ad630047735b4b2b216fd30115c4929c13ed6b242bd288170b"
  end

  depends_on "dotnet@10"

  resource "document.spdx.json", :test do
    url "https://raw.githubusercontent.com/CycloneDX/cyclonedx-cli/refs/tags/v0.32.0/tests/cyclonedx.tests/Resources/document.spdx.json"
    sha256 "6fed40c4b4774821c2a9002b3ad44c1234987ff5d7780345ed29b01e942b8142"
  end

  deny_network_access!

  def dotnet = deps.find { |d| d.name.match? Version.formula_optionally_versioned_regex(:dotnet) }.to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    system "dotnet", "restore", "src/cyclonedx/cyclonedx.csproj", "--use-current-runtime",
           "-p:TargetFrameworks=net#{dotnet.version.major_minor}"
  end

  def install
    ENV["XDG_RUNTIME_DIR"] = buildpath
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:DebugSymbols=false
      -p:DebugType=None
      -p:PublishSingleFile=true
      -p:PublishTrimmed=false
      -p:Version=#{version}
    ]
    system "dotnet", "publish", "src/cyclonedx/cyclonedx.csproj", *args
    bin.install_symlink libexec/"cyclonedx"
  end

  test do
    testpath.install resource("document.spdx.json")
    system bin/"cyclonedx", "convert", "--input-file=document.spdx.json", "--output-file=bom.cdx.json"
    system bin/"cyclonedx", "validate", "--input-file=bom.cdx.json"

    assert_equal version.to_s, shell_output("#{bin}/cyclonedx --version").strip
  end
end
