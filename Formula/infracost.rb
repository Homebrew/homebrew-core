class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.5.2.tar.gz"
  sha256 "98e805eb36dcaf784bfdf765631bbb191b4bf4c41b754b71fc483878413c2d63"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "73ae87a10144e1917cc00da5ecbc98bd35e7b9199634c68a4c9402e7c2da2832" => :catalina
    sha256 "38deed810d34abfdb2cd7940b399ce392b6ff971480b25179400e4b58e3bb4a7" => :mojave
    sha256 "4b52b8111ab72c54b7677f851ad0d4c120b09dfdd55ca269e03b33c75620600c" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args, "./cmd/infracost"
  end

  test do
    (testpath/"ami.tf").write <<~EOS
      provider "aws" {
        region                      = "us-east-1"
        s3_force_path_style         = true
        skip_credentials_validation = true
        skip_metadata_api_check     = true
        skip_requesting_account_id  = true
        access_key                  = "mock_access_key"
        secret_key                  = "mock_secret_key"
      }

      resource "aws_instance" "web_app" {
        ami           = "fake1"
        instance_type = "t3.micro"

        root_block_device {
          volume_size = 15
        }
      }
    EOS

    expected = <<~EOS
      [{
        "name": "aws_instance.web_app",
        "hourlyCost": "0.01245479452054795",
        "monthlyCost": "9.0920000000000035",
        "costComponents": [{
          "name": "Compute (on-demand, t3.micro)",
          "unit": "hours",
          "hourlyQuantity": "1",
          "monthlyQuantity": "730",
          "price": "0.0104",
          "hourlyCost": "0.0104",
          "monthlyCost": "7.592"
        }],
        "subresources": [{
          "name": "root_block_device",
          "hourlyCost": "0.00205479452054795",
          "monthlyCost": "1.5000000000000035",
          "costComponents": [{
            "name": "Storage",
            "unit": "GB-months",
            "hourlyQuantity": "0.0205479452054795",
            "monthlyQuantity": "15",
            "price": "0.1",
            "hourlyCost": "0.00205479452054795",
            "monthlyCost": "1.5"
          }]
        }]
      }]
    EOS

    output = shell_output("#{bin}/infracost --no-color --tfdir . --output json")
    assert_equal JSON.parse(expected), JSON.parse(output)
  end
end
