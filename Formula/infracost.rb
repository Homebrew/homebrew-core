class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.5.1.tar.gz"
  sha256 "48a7d0d5921110af037cf90e48471efb949864dbfdcf16ef8b171f1d4c2c393f"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

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
