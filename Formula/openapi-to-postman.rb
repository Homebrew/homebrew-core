require "language/node"

class OpenapiToPostman < Formula
  desc "Convert OpenAPI v3 specs to Postman Collection v2 format"
  homepage "https://github.com/postmanlabs/openapi-to-postman"
  url "https://registry.npmjs.org/openapi-to-postmanv2/-/openapi-to-postmanv2-0.0.15.tgz"
  sha256 "d38df0bbf4460f464f5124ff6cbc9e246e71af0cee0d174fab9a9c3c0c610787"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match /0.0.1/, shell_output("#{bin}/openapi2postmanv2 --version")

    path = testpath/"callback-example.yaml"
    path.write <<~EOS
      openapi: 3.0.0
      info:
        title: Callback Example
        version: 1.0.0
      paths:
        /streams:
          post:
            description: subscribes a client to receive out-of-band data
            parameters:
              - name: callbackUrl
                in: query
                required: true
                description: |
                  the location where data will be sent.  Must be network accessible
                  by the source server
                schema:
                  type: string
                  format: uri
                  example: https://tonys-server.com
            responses:
              '201':
                description: subscription successfully created
                content:
                  application/json:
                    schema:
                      description: subscription information
                      required:
                        - subscriptionId
                      properties:
                        subscriptionId:
                          description: this unique identifier allows management of the subscription
                          type: string
                          example: 2531329f-fb09-4ef7-887e-84e648214436
            callbacks:
              # the name `onData` is a convenience locator
              onData:
                # when data is sent, it will be sent to the `callbackUrl` provided
                # when making the subscription PLUS the suffix `/data`
                '{$request.query.callbackUrl}/data':
                  post:
                    requestBody:
                      description: subscription payload
                      content:
                        application/json:
                          schema:
                            properties:
                              timestamp:
                                type: string
                                format: date-time
                              userData:
                                type: string
                    responses:
                      '202':
                        description: |
                          Your server implementation should return this HTTP status code
                          if the data was received successfully
                      '204':
                        description: |
                          Your server should return this HTTP status code if no longer interested
                          in further updates
    EOS

    assert_match /Conversion successful Collection/, shell_output("#{bin}/openapi2postmanv2 -s #{path} -o #{testpath}/collection.json -p")
    assert_predicate testpath/"collection.json", :exist?, "collection.json file should exist"
  end
end
