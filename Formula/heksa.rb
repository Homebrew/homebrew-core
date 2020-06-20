class Heksa < Formula
  desc "CLI hex dumper with colors"
  homepage "https://github.com/raspi/heksa"
  url "https://github.com/raspi/heksa/archive/v1.12.1.tar.gz"
  sha256 "7edb16d1d28518149afadf3134f56619cf10ccc788355dde8197a38c6de54277"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match /P.*N.*G/, shell_output("#{bin}/heksa -l 16 -f asc -o no #{test_fixtures("test.png")}")
  end
end
