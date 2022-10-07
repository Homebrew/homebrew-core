class Mimirtool < Formula
  desc "CLI tool for operating/managing Grafana Mimir or GrafanaCloud Metrics"
  homepage "https://grafana.com/docs/mimir/latest/operators-guide/tools/mimirtool/"
  url "https://github.com/grafana/mimir/releases/"
  version "2.3.1"
  sha256 "6ce99ef47d98bf240ada2acfe0b8e91641c326baf6f280e1c3db57f1cae6e0b6"
  license "AGPL-3.0-only"

  on_macos do
    on_arm do
      url "https://github.com/grafana/mimir/releases/download/mimir-2.3.1/mimirtool-darwin-arm64"
      sha256 "e6ec1a30d062e775265e94a685fdad090817a038db8168fea65a3064bd533be5"

      def install
        bin.install "mimirtool-darwin-arm64" => "mimirtool"
      end
    end
    on_intel do
      url "https://github.com/grafana/mimir/releases/download/mimir-2.3.1/mimirtool-darwin-amd64"
      sha256 "bcaf732700c1ce631a3137a935239cc52d2e5dfcf1b1c581d96bc9951c57d509"

      def install
        bin.install "mimir-darwin-amd64" => "mimirtool"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/grafana/mimir/releases/download/mimir-2.3.1/mimirtool-linux-arm64"
      sha256 "4c5b09385ed8bb4f141450fe511ba1671b40eb9b543e43de2ca0823e87e1f594"

      def install
        bin.install "mimirtool-linux-arm64" => "mimirtool"
      end
    end
    on_intel do
      url "https://github.com/grafana/mimir/releases/download/mimir-2.3.1/mimirtool-linux-amd64"
      sha256 "1d1de1948963e05f6f3706613fc2bac235c4b8f0205cfd200b6588790bfe1511"

      def install
        bin.install "mimirtool-linux-amd64" => "mimirtool"
      end
    end
  end

  test do
    assert_match "Mimirtool, version 2.3.1 (branch: release-2.3, revision: 64a71a566)",
      shell_output("#{bin}/mimirtool version")
  end
end