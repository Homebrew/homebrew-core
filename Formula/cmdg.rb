class Cmdg < Formula
  desc "Gmail CLI - Copyright Thomas Habets thomas@habets.se 2019"
  homepage "https://github.com/ThomasHabets/cmdg"
  url "https://github.com/ThomasHabets/cmdg/archive/cmdg-1.00.tar.gz"
  sha256 "4a723a812eae27fac1334e14cfc9b92955e6a3c1c43f1de87aa294d72bb7dc25"
  depends_on "go"
  def install
    ENV["GOPATH"] = buildpath
    system "go", "get", "github.com/mattn/go-runewidth"
    system "go", "get", "github.com/pkg/errors"
    system "go", "get", "github.com/sirupsen/logrus"
    system "go", "get", "golang.org/x/crypto/ssh/terminal"
    system "go", "get", "golang.org/x/oauth2"
    system "go", "get", "golang.org/x/text/encoding"
    system "go", "get", "google.golang.org/api/gmail/v1"
    system "go", "get", "github.com/ThomasHabets/cmdg/cmd/cmdg"
    system "go", "build", "github.com/ThomasHabets/cmdg/cmd/cmdg"
    bin.install "./cmdg" => "cmdg"
  end

  test do
    system "#{bin}/cmdg", "--help"
  end
end
